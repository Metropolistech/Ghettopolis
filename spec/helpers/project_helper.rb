# create a project
def create_project(title: "Marge's project", status: "")
  sRand = SecureRandom
  create_user
    .create_project! data: {
      title: title,
      youtube_id: sRand.hex(4),
      status: status,
      description: sRand.hex,
      tag_list: "#{sRand.hex(2)},#{sRand.hex(2)},#{sRand.hex(2)}"
    }
end
