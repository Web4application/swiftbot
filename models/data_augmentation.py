# models/data_augmentation.py

from tensorflow.keras.preprocessing.image import ImageDataGenerator

def augment_images(image_directory, batch_size=32):
    """
    Perform data augmentation on image data for training.
    
    Parameters:
    - image_directory: str, path to the directory containing images.
    - batch_size: int, number of images per batch.
    
    Returns:
    - Augmented data generator.
    """
    
    # Create an ImageDataGenerator instance with various augmentation options
    datagen = ImageDataGenerator(
        rotation_range=40,
        width_shift_range=0.2,
        height_shift_range=0.2,
        shear_range=0.2,
        zoom_range=0.2,
        horizontal_flip=True,
        fill_mode='nearest'
    )

    # Apply transformations to images in the directory
    image_data_flow = datagen.flow_from_directory(
        image_directory,
        target_size=(150, 150),  # Resize all images to 150x150
        batch_size=batch_size,
        class_mode='binary'  # Assuming binary classification (adjust for multi-class)
    )
    
    return image_data_flow
