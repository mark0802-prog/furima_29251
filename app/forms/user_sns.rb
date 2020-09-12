class UserSns
  include ActiveModel::Model
  attr_accessor :sns_id, :user_id

  def update
    SnsCredential.find(sns_id).update(user_id: user_id)
  end
end
