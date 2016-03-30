
require 'animation'

function moveRightSpriteFunction(animation)
    animation.subject.imageName = "individuals/linkRight.png"
    animation.subject:updateImage()
end

function moveLeftSpriteFunction(animation)
    animation.subject.imageName = "individuals/linkLeft.png"
    animation.subject:updateImage()
end

function moveUpSpriteFunction(animation)
    animation.subject.imageName = "individuals/linkUp.png"
    animation.subject:updateImage()
end

function moveDownSpriteFunction(animation)
    animation.subject.imageName = "individuals/linkDown.png"
    animation.subject:updateImage()
end

function attackSpriteFunction(animation)
    animation.subject.imageName = "individuals/linkRightAttack.png"
    animation.subject:updateImage()
end

function successSpriteFunction(animation)
    animation.subject.imageName = "individuals/linkSuccess.png"
    animation.subject:updateImage()
end

