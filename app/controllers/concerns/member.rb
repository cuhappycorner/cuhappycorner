module Member
  extend ActiveSupport::Concern

  def activate_member(operator, member, cu_link_id)
    member.cu_link_id = cu_link_id
    member.activated = true
    member.activated_at = Time.zone.now
    member.save
  end

end