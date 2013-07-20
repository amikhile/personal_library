class AddLocaleToLanguages < ActiveRecord::Migration
  def change
    rename_column :languages, :name, :language
    add_column :languages, :locale, :string
    add_column :languages, :code3, :string
  end
end
