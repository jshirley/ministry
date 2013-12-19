# The Ministry of Potential Projects

## Synopsis

It's hard to figure out what to work on and who to work on it with. Also, many people are cross-functional. Wouldn't it be nice to see a list of projects that need _your_ help? And then have those projects be described in terms that make you want to work on them?

Things like:

* A boring description
* What is the objective of this work?
* How do we measure success?
* What is the worst case scenario?

Wnat what happens after the project is underway or even completed? It's forgotten in most cases. Sometimes it's stored as an archived Epic or Sprint, perhaps even a wiki page. None of these are particularly meaningful and they are hard to pull out structured data from. Especially when you want to look at success and failures over time.

A visual representation of what typically happens after a project is "done":

![](http://i.imgur.com/eEvzZCb.gif)

## What is a project?

A project is a discrete (and potentially discreet, so we should have a "Private" flag) piece of work. In Agile terms, it should be something like a User Story or as large as a sprint. Never bigger.

### But my projects are huuuuuuuge (series)

Then they should be a _series of projects_ which all have different requirements and measurements of success and failure points. When a project is fully staffed and completed, the next project can advance. People can come and go as necessary. This helps keep resources free when they aren't actively being used. JIT People Allocation!

## Projects are made of people!

The most important element of a project are the people. This is how a project can be considered "backed". Kickstarter you pledge money, here you pledge your knowledge and talent. If you don't have talent you at least have time.

When someone creates a project they fill out the roles required. Something tech heavy may require a few developers, a designer, someone to write tests or perhaps documentation. A rockstar ninja awesome 1%er developer may not feel up for coding on a new project but can slot themselves in for writing documentation. They apply for that role and the project owner can decline or accept that request. Similarly, a project owner can make a plea to a specific person. A desperate cry for help will be sent to the desired person who can then accept the invitation to participate.

Once all the roles in the project are satisfied the project can advance into an "Approved" state. This doesn't mean it is active, because people need to coordinate.

![](http://www.eminem.net/tracks/the_real_slim_shady/images/the_real_slim_shady.jpg)

## Scheduling Projects

Scheduling is more just in the concept of milestones. A mistletoe is a date with a label. It could be a start date or an end date or a review date or a date with your significant otter.

![](http://veryhilarious.com/wp-content/uploads/2012/09/significant-otter.jpg)

### For the Borg

In a structured corporate environment, the automatons will likely coordinate their project with a sprint. If you aren't using Agile, then just turn off your computer. The project then would have mistlestones for the start and optimistic ending dates. Ideally this will never go beyond 2 weeks, because Node.js will have like 3 releases between then. At this point, the project tracking is really just tracking. You should be using a good ticketing system to track the individual items that need to happen. It would be great if this system tapped into JIRA and GitHub Issues. Other ticketing systems can be left out to think about why they're not good enough.

### And the Hippies 

But Open Source projects are really important, too! These projects should be supported and dates don't make the same amount of sense when the people doing the work are trying to fit it in between their day jobs and fulfilling their duties in Anonymous. Here the missiletones should be dates for people to rally towards and preventing procrastination.

### Dates specific to roles

A developer may not care about when the documentation should be ready, but the person in charge of the documentation doesn't want the code to change. The documentator would set a millstone for "Code Freeze or your puppy dies" based on this need.

![](http://i.imgur.com/FENmz.png)

## Finding what to do

Everything should be searchable. Thanks, Google. Our projects should be, too. Based on permissions, whether or not you have visibility into the organization or it's a public project will matter. The goal is to find people who can help or who you can help.

## Tools & Resources

Dominant language: Ruby

Framework: Rails 4, using [rails-assets](https://rails-assets.org/) rather than stuffing deps in vendor

Testing: rspec

UI Framework: Bootstrap 3, not managed by rails-assets so we can easily override.

Page Enhancement: Knockout

Chimp Attract: jQuery

Database: Postgres

Search: ElasticSearch (using the (re?)[tire](https://github.com/karmi/retire) gem over the official ES api)

Email: ActiveMailer utilizing the [Zurb Ink Framework](http://zurb.com/ink/)


# User Stories and Use Cases

## Open Source

To Be Written

## Hackathons

To Be Written

## Project Founders

Project Founders are people who are backing the project. The buck stops with them.

Ideally, they have stakeholders and have thought about all that is necessary
for the project to succeed. This includes the roles the project needs to have
filled, what would go wrong and the real benefit.

### Use Case: Vetting an Idea

While Ministry itself does not have discussion threads (yet?), it is a good
idea to discuss the various questions raised in any project. Ministry allows
free-form values to be set, but defaults to a set of specific questions that
should allow the important discussions to be had and answers defined.

The next step is getting people to fill the necessary roles. The founder
will define what roles are necessary for the project. Until all the roles
are filled, the project cannot advance into "Scheduling".

If a founder cannot find people to participate in the project, it's probably a
bad idea and you should feel bad.

### Use Case: When to work on what

When all roles are filled on a project, Ministry should help with scheduling.

This is a difficult problem to solve, but one that would be really powerful.

Getting a list of projects that are filled and finding out when all
participants are available would be great to see how sprints can be managed.

## The Unutilized

_People who are looking for things to do, finding interesting projects._

To Be Written

## Overseers

_People monitoring staff utilization and the momentum of a company or even open source product_

To Be Written

