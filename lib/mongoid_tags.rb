# Basic tagging system for mongoid documents.
# jpemberthy 2010
#
# class User
#   include Mongoid::Document
#   include Mongoid::Document::Taggable
# end
#
# @user = User.new(:name => "Bobby")
# @user.tag_list = "awesome, slick, hefty"
# @user.tags     # => ["awesome","slick","hefty"]
# @user.save
#
# User.tagged_with("awesome") # => @user
# User.tagged_with(["slick", "hefty"]) # => @user
#
# @user2 = User.new(:name => "Bubba")
# @user2.tag_list = "slick"
# @user2.save
#
# User.tagged_with("slick") # => [@user, @user2]

module Mongoid
  module Document
    module Taggable
      def self.included(base)
        base.class_eval do |base1|
          base1.field :tags, type: Array
          base1.index(tags: 1)

          include InstanceMethods
          extend ClassMethods
        end
      end

      module InstanceMethods
        def tag_list=(tags)
          self.tags = tags.split(',').collect(&:strip).delete_if(&:blank?)
        end

        def tag_list
          tags.join(', ') if tags
        end
      end

      module ClassMethods
        # let's return only :tags
        def tags
          all.only(:tags).collect(&:tags).flatten.uniq.compact
        end

        def tagged_like(_perm)
          _tags = tags
          _tags.delete_if { |t| !t.include?(_perm) }
        end

        def tagged_with(tags)
          tags = Array.wrap(tags)
          criteria.in(tags: tags)
        end
      end
    end
  end
end
