# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+:votes => 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize
      # If it has 10**(n-1) tomatoes, grant tomatoer-n badge
      (1..5).each do |n|
        grant_on 'tomatoes#create', :badge => 'tomatoer', :level => n, :to => :user do |tomato|
          tomato.user.tomatoes.count >= 10**(n-1)
        end
      end

      # If it has 4*n tomatoes in a row, grant diligent-tomatoer-n badge
      (1..10).each do |n|
        grant_on 'tomatoes#create', :badge => 'diligent_tomatoer', :level => n, :to => :user do |tomato|
          tomato.user.tomatoes_after(Time.zone.now.beginning_of_day).count >= 4*n
        end
      end

      # If it has tomatoes for 2**n days in a row, grant assiduous-tomatoer-n badge
      (1..10).each do |n|
        grant_on 'tomatoes#create', :badge => 'assiduous_tomatoer', :level => n, :to => :user do |tomato|
          # TODO
        end
      end
    end
  end
end
