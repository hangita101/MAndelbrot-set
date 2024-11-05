from PIL import Image

def ascii_art_to_image(input_file, output_file, char_to_pixel_mapping=None):
    with open(input_file, 'r') as file:
        lines = file.readlines()

    width = max(len(line.rstrip()) for line in lines)  
    height = len(lines)

    if char_to_pixel_mapping is None:
        char_to_pixel_mapping = {'@': 255, '#':200,'%':155,'.':100,' ': 0}  

    image = Image.new('L', (width, height), 0)  

    for y, line in enumerate(lines):
        for x, char in enumerate(line.rstrip()): 
            pixel_value = char_to_pixel_mapping.get(char, 255)  
            image.putpixel((x, y), pixel_value)

    image.save(output_file, 'JPEG')

    print(f"Image saved as {output_file}")

input_file = 'save.txt'  
output_file = 'output_image.jpg'  

ascii_art_to_image(input_file, output_file)
