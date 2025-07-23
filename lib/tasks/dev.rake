desc "Hydrate the database with some sample data to look at so that developing is easier"
task({ :sample_data => :environment }) do
  # Reset primary key sequences (optional but fine to leave)
  ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end

  # ✅ Correct deletion order: destroy deliveries first, then users
  Delivery.destroy_all
  User.destroy_all

  usernames = ["alice", "bob", "carol", "dave", "eve"]

  usernames.each do |username|
    user = User.new
    user.email = "#{username}@example.com"
    user.password = "appdev"
    user.save!

    10.times do
      delivery = Delivery.new
      delivery.user_id = user.id
      delivery.description = Faker::Commerce.product_name
      delivery.details = "#{["FedEx", "UPS", "USPS"].sample} tracking ##{rand(1000000000000)}" if rand < 0.5
      delivery.expected_on = Faker::Date.between(from: 1.month.ago, to: 2.weeks.from_now)

      delivery.received = delivery.expected_on < Time.now ? [true, false].sample : false

      delivery.save!
    end
  end

  puts "✅ Sample data loaded!"
end
