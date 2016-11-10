class SubscribeUserToMailingListJob < ActiveJob::Base
  queue_as :default
  def perform(user)
    Gibbon::Request.lists('237f06a25b').members(Digest::MD5.hexdigest(user.email)).upsert(body: { email_address: user.email, status: 'subscribed', merge_fields: { ENAME: user.name_translations[:en], CNAME: user.name_translations[:zh_HK], DNAME: user.display_name, CU: user.cuid_type, CUID: user.cuid, ACTIVATED: user.activated.to_s, GENDER: user.gender, MAJOR: user.major.code, PHONE: user.mobile, ADMISSION: user.year_of_admission.to_s, GRADUATION: user.year_of_graduation.to_s, RESIDENT: user.cu_resident.to_s, ROLE: user.role(select: :name).collect(&:name).join(', ') } })
  end
end
