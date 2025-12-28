require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "post can be created without image" do
    post = Post.new(
      title: "Test Post",
      body: "Test body content"
    )
    
    assert post.save, "Post should be saved without image"
    assert_not post.image.attached?, "Image should not be attached"
  end

  test "post can have image attached" do
    post = Post.create!(
      title: "Post with image",
      body: "Post body"
    )
    
    # Создаем временное изображение
    image_path = Rails.root.join("tmp", "test_image.jpg")
    File.open(image_path, "wb") do |file|
      file.write("fake image content")
    end
    
    post.image.attach(
      io: File.open(image_path),
      filename: "test_image.jpg",
      content_type: "image/jpeg"
    )
    
    assert post.image.attached?, "Image should be attached"
    
    # Удаляем временный файл
    File.delete(image_path) if File.exist?(image_path)
  end

  test "post validation allows valid image formats" do
    post = Post.new(
      title: "Test Post",
      body: "Test body"
    )
    
    # Создаем временное изображение
    image_path = Rails.root.join("tmp", "valid_image.jpg")
    File.open(image_path, "wb") do |file|
      file.write("fake image content")
    end
    
    post.image.attach(
      io: File.open(image_path),
      filename: "valid_image.jpg",
      content_type: "image/jpeg"
    )
    
    assert post.valid?, "Post with valid image should be valid"
    
    # Удаляем временный файл
    File.delete(image_path) if File.exist?(image_path)
  end
end
