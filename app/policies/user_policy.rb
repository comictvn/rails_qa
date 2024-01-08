class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @model = model
  end

  def update?
    current_user.admin? || model.id == current_user.id
  end
end
