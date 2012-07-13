desc "This task queues the AwardCrowns job"
task :award_crowns => :environment do
  Resque.enqueue(AwardCrowns)
end