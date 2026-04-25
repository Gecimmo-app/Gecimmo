import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex to find Scaffold instantiations and replace backgroundColor
    # This is a basic parser that looks for 'Scaffold(' and then finds 'backgroundColor:' before the matching ')'
    
    # Actually, simpler: replace known page background colors with 0xFFEFF6FF everywhere
    # Only replace 'backgroundColor: Colors.white' if it looks like it's inside Scaffold
    
    new_content = re.sub(r'backgroundColor:\s*const Color\(0xFFF[0-9A-F]{5}\),?', 'backgroundColor: const Color(0xFFEFF6FF),', content)
    new_content = re.sub(r'backgroundColor:\s*Color\(0xFFF[0-9A-F]{5}\),?', 'backgroundColor: const Color(0xFFEFF6FF),', new_content)
    
    # Theme color definitions
    new_content = re.sub(r'Color\(0xFFF[0-9A-F]{5}\)', 'Color(0xFFEFF6FF)', new_content)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
