require 'tire/search/filter'

module ProjectSearch extend ActiveSupport::Concern

  module ClassMethods

    # Query to return all projects.
    @@query_find_all = lambda do |boolean|
      boolean.should { all }
    end

    # Query to boost staff projects versus Pending
    # TODO This might need to be changed to a terms
    # query that contains all other statuses to be used
    # in other contexts.
    @@query_boost_staffing = lambda do |boolean|
      boolean.should do
        boosting negative_boost: 0.2 do
          positive { term :current_status, "Staffing" }
          negative { term :current_status, "Pending" }
        end
      end
    end

    # Filter for returning Projects that are Staffable
    # by way of Status checks
    @@filter_staffable = Tire::Search::Filter.new('terms', { :current_status => ["Staffing", "Pending" ] })
    
    # Filter for returning Projects that need to fill a
    # role.
    @@filter_needs_staff = Tire::Search::Filter.new('range', { 'roles.needed_count'.to_sym => { :gt => 0 } })

    @@filter_skills = lambda do |skills|
      Tire::Search::Filter.new('terms', { :tags => skills })
    end

    def matched_to_user(user)
      u = user
      Project.tire.search do
        # This is a useless and filter, but using it
        # allows us to pass a Filter object. I can't find
        # a way to get filter to take an object. :(
        filter :and, [ @@filter_skills.call(u.skill_list) ]
        facet 'current_status' do
          terms :current_status
        end
        facet('role') { terms 'roles.name'.to_sym }
        facet('tag') { terms :tags }
      end
    end

    def need_staff
      Project.tire.search do
        query do
          boolean &@@query_find_all
          boolean &@@query_boost_staffing
        end
        filter :and, @@filter_staffable, @@filter_needs_staff
        facet 'current_status' do
          terms :current_status
        end
        facet('role') { terms 'roles.name'.to_sym }
        facet('tag') { terms :tags }
      end
    end

    def need_staff_with_skills(skills)
      Project.tire.search do
        query do
          boolean &@@query_find_all
          boolean &@@query_boost_staffing
        end
        filter :and,
          @@filter_staffable,
          @@filter_needs_staff,
          @@filter_skills.call(skills)
        facet 'current_status' do
          terms :current_status
        end
        facet('role') { terms 'roles.name'.to_sym }
        facet('tag') { terms :tags }
      end
    end

  end
end