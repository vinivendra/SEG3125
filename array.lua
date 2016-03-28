function getSize(array)
    return table.getn(array)
end

function push(array, element)
    size = getSize(array)
    array[size + 1] = element
end

function pushAction(array, newAction)
    local size = getSize(array)
    local addAction = array[size]
    array[size] = newAction
    array[size+1] = addAction
end 

function removeElement(array, element)
    size = getSize(array)

    for i=1,size do
        if array[i] == element then
            print("found", i, element.name)

            for j=i,(size - 1) do
                print("moving", j+1, array[j + 1].name)
                array[j] = array[j + 1]
            end

            print("end", size, array[size].name)

            array[size] = nil
            
            return true
        else
            print("diff", i, element.name)
        end
    end

    return false
end

function removeAtIndex(array, index)
    size = getSize(array)

    for i=index,size do
        array[i] = array[i+1]
    end

    array[size] = nil
end

function indexOf(array, element)
    size = getSize(array)

    for i=1,size do
        if array[i] == element then
            return i
        end
    end

    return -1
end












