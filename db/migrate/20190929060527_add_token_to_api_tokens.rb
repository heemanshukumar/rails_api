class AddTokenToApiTokens < ActiveRecord::Migration[5.1]
  def change
    add_column :api_tokens, :token, :string
    add_column :api_tokens, :user_id, :integer
    add_column :api_tokens, :expire, :datetime
  end
end
