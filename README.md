## Objective

this actions verify if the pull request as a milestone set up.

The yml file triggers the action on the following events:
- opened
- edited
- review_requested

One downside is that there is no "milestoned" or "demilestoned" trigger on the pull request.
If a dev does not set up its milestone and needs to merge it, he will have to run manually the job that failed once he has set up the milestone.


In the script, the milestone is fetch each time, because if a dev re-run the action manually, we need to
get the newest milestone.

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
