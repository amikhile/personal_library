class FilterTemplate < ActiveRecord::Base

  has_and_belongs_to_many :content_types
  has_and_belongs_to_many :media_types
  has_and_belongs_to_many :languages
  has_many :filter_template_names

  accepts_nested_attributes_for :filter_template_names

  def name
    @code3 = Language::LOCALE_CODE3[I18n.locale.to_s] || :en
    names = self.filter_template_names.select { |name| name.code3 == @code3 }
    names.first.name
  end

end
