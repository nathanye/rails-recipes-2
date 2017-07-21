class Event < ApplicationRecord

  include RankedModel
  ranks :row_order

 validates_presence_of :name, :friendly_id

 validates_uniqueness_of :friendly_id
 validates_format_of :friendly_id, :with => /\A[a-z0-9\-]+\z/

 def to_param
   self.friendly_id
 end

  has_many :registrations, :dependent => :destroy

  mount_uploader :logo, EventLogoUploader
  mount_uploaders :images, EventImageUploader
  serialize :images, JSON

  has_many :attachments, :class_name => "EventAttachment", :dependent => :destroy
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => :all_blank

 protected

 def generate_friendly_id
   self.friendly_id ||= SecureRandom.uuid
 end

 STATUS = ["draft", "public", "private"]
 validates_inclusion_of :status, :in => STATUS

 belongs_to :category, :optional => true

 has_many :tickets, :dependent => :destroy
 accepts_nested_attributes_for :tickets, :allow_destroy => true, :reject_if => :all_blank

 scope :only_public, -> { where( :status => "public" ) }
 scope :only_available, -> { where( :status => ["public", "private"] ) }

end
