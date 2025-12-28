# Удаляем существующие посты для чистоты теста
Post.destroy_all

# Создаем тестовые изображения
def create_test_image(color, width, height, filename)
  # Создаем простое изображение с помощью RMagick или MiniMagick
  # Для простоты создадим временный файл с цветным фоном
  
  require 'fileutils'
  
  # Создаем директорию для временных изображений
  temp_dir = Rails.root.join('tmp', 'test_images')
  FileUtils.mkdir_p(temp_dir) unless Dir.exist?(temp_dir)
  
  image_path = temp_dir.join(filename)
  
  # Создаем простое SVG изображение
  svg_content = <<~SVG
    <svg width="#{width}" height="#{height}" xmlns="http://www.w3.org/2000/svg">
      <rect width="100%" height="100%" fill="#{color}" />
      <text x="50%" y="50%" font-family="Arial" font-size="20" fill="white" text-anchor="middle" dominant-baseline="middle">
        #{filename.split('.').first.humanize}
      </text>
    </svg>
  SVG
  
  File.write(image_path, svg_content)
  image_path
end

# Создаем и загружаем тестовые изображения
puts "Creating test images..."

nature_image_path = create_test_image("#2E8B57", 800, 600, "nature_landscape.svg")
tech_image_path = create_test_image("#4169E1", 800, 600, "tech_background.svg")
travel_image_path = create_test_image("#FF8C00", 800, 600, "travel_adventure.svg")

puts "Test images created successfully!"

# Создаем тестовые посты
puts "Creating test posts..."

# Пост без изображения
post1 = Post.create!(
  title: "Первый пост без изображения",
  body: "Это тестовый пост без изображения. Здесь вы можете увидеть, как выглядит пост, когда к нему не прикреплено изображение. Это полезно для проверки отображения постов в списке и на странице просмотра."
)

# Пост с изображением природы
post2 = Post.create!(
  title: "Пост с изображением природы",
  body: "Этот пост содержит изображение природы. Изображение должно отображаться как в списке постов, так и на странице просмотра. Это помогает проверить работу Active Storage и отображение изображений в разных представлениях."
)

post2.image.attach(
  io: File.open(nature_image_path),
  filename: "nature_landscape.svg",
  content_type: "image/svg+xml"
)

# Технологический пост
post3 = Post.create!(
  title: "Технологический пост",
  body: "Технологии развиваются с невероятной скоростью. В этом посте мы рассмотрим последние достижения в области искусственного интеллекта, машинного обучения и других передовых технологий, которые меняют наш мир."
)

post3.image.attach(
  io: File.open(tech_image_path),
  filename: "tech_background.svg",
  content_type: "image/svg+xml"
)

# Путешествия и приключения
post4 = Post.create!(
  title: "Путешествия и приключения",
  body: "Путешествия открывают новые горизонты и расширяют кругозор. В этом посте вы найдете вдохновляющие истории о путешествиях, советы для туристов и рекомендации по самым интересным местам для посещения."
)

post4.image.attach(
  io: File.open(travel_image_path),
  filename: "travel_adventure.svg",
  content_type: "image/svg+xml"
)

puts "Test posts created successfully!"
puts "Total posts created: #{Post.count}"

# Удаляем временные файлы
File.delete(nature_image_path) if File.exist?(nature_image_path)
File.delete(tech_image_path) if File.exist?(tech_image_path)
File.delete(travel_image_path) if File.exist?(travel_image_path)

puts "Test data setup completed!"
