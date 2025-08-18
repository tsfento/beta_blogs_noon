FactoryBot.define do
  factory :monthly_summary do
    user { nil }
    month { "2025-08-18" }
    total_likes { 1 }
  end
end
