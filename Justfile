_default:
    just -l

# Showtime baby
slides:
    presenterm -p ./slides.md

# Create PDF of slides
pdf:
    presenterm --export-pdf slides.md
