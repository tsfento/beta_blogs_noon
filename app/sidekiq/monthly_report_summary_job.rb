class MonthlyReportSummaryJob
  include Sidekiq::Job

  def perform(*args)
    last_month = Date.today.last_month

    User.find_each do |user|
      total_likes = 0

      user.blogs.where(created_at: last_month.beginning_of_month..last_month.end_of_month).each do |blog|
        total_likes += blog.likes.count
      end

      MonthlySummary.create(user: user, month: last_month.beginning_of_month) do |summary|
        summary.total_likes = total_likes
      end

      puts "Monthly report summary created for #{user.username} with #{total_likes} likes."
    end
  end
end
