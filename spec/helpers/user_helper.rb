def create_user(admin: false)
  user = User
    .create({
      username: SecureRandom.hex(2),
      firstname: SecureRandom.hex(2),
      lastname: SecureRandom.hex(2),
      email: "#{SecureRandom.hex(2)}@contact.com",
      password: SecureRandom.hex,
      is_admin: admin
    })
  block_given? ? (yield user) : user
end

def create_admin
  create_random_user admin: true
end

class User
  def create_random_project(title: nil, status: "draft")
    sRand = SecureRandom
    p = Project.create({
      author: self,
      title: title || sRand.hex(4),
      youtube_id: sRand.hex(2),
      status: status,
      description: sRand.hex,
      tag_list: "#{sRand.hex(2)},#{sRand.hex(2)},#{sRand.hex(2)}",
    })
    p.save!
    p
  end
end
