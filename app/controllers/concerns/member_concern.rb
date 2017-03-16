module MemberConcern
  extend ActiveSupport::Concern

  def activate_member(operator, member, cu_link_id)
    member.cu_link_id = cu_link_id
    member.activated = true
    member.activated_at = Time.zone.now
    if not member.save
      flash[:error] << member.errors.full_messages
      return false
    else
      return true
    end
  end

  def mirgrate_member(member, amount)
    operator = Computer.first
    project = Corner::Account::Project.find_by(name: "2016 Sep System Migration")

    transaction = Corner::Account::MigrationCreditTransaction.create(operator: operator, debitor: HappyCorner.first.account.first, creditor: member.account, detail: "Migration from Old System 舊系統遷移", project: project)
    if not transaction.valid?
      flash[:error] << transaction.errors.full_messages
      return false
    else
      return true
    end
  end

end