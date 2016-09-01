module Member
  extend ActiveSupport::Concern

  def activate_member(operator, member, cucardid)
    member.cu_identity_no = cucardid
    member.activated = true
    member.activated_at = Time.now
    member.save
  end

end