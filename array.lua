
getmetatable('').__index = function(str,i)
  if type(i) == 'number' then
    return string.sub(str,i,i)
  else
    return string[i]
  end
end

function getName(object)
    if object ~= nil and object.name ~= nil then
        return object.name
    else
        return object
    end
end

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
            for j=i,(size - 1) do
                array[j] = array[j + 1]
            end

            array[size] = nil
            
            return true
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

function printArray(array, name)
    print("==", name)

    size = getSize(array)

    for i=1,size do
        -- Print element
        print("- ", getName(array[i]))

        -- Print sub-elements
        element = array[i].next
        while element ~= nil do
            print("        - ", getName(element))
            element = element.next
        end

    end

    print("--")
end








