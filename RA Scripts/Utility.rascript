// A cluster is defined as an array whose elements all differ by a single quantum value with at least one element.
// For instance, an array containing the values [ 1, 2, 3, 4, 6, 7, 9 ] has three clusters:
// [ 1, 2, 3, 4 ], [ 6, 7 ], and [ 9 ]
function GenerateClustersFromList(data)
{
    clusters = []
    currentElement = -1
    currentCluster = []
    for i in data
    {
        if (i == currentElement + 1 || currentElement == -1)
        {
            currentElement = i
            array_push(currentCluster, currentElement)
        }
        else
        {
            array_push(clusters, currentCluster)
            currentElement = i
            currentCluster = [ currentElement ]
        }
    }
    
    // Get the range we were just working on if it has elements.
    if (length(currentCluster) > 0)
    {
        array_push(clusters, currentCluster)
    }
    
    return clusters
}

function ConvertClustersToRanges(clusters)
{
    ranges = []
    
    for cluster in clusters
    {
        min = cluster[0]
        max = cluster[length(cluster) - 1]
        array_push(ranges, { "min": min, "max": max })
    }
    
    return ranges
}

function ArrayToString(array)
{
    ret = "[ "
    for i in array
    {
        ret = ret + i + ", "
    }
    return ret + " ]"
}

testData = [ 1, 2, 3, 4, 6, 7, 8, 10, 12, 15, 16, 17 ]
clusters = GenerateClustersFromList(testData) // [ [ 1, 2, 3, 4], [ 6, 7, 8 ], [10], [12], [15, 16, 17] ]
ranges = ConvertClustersToRanges(clusters) // [ { "min": 1, "max": 4}, { "min": 6, "max": 8 }, { "min": 10, "max": 10 } ... ]

for cluster in clusters
{
    achievement(title = ArrayToString(cluster), description = "", points = 0, trigger = always_false())
}

function IsAPointer(addr) => byte(addr + 3) == 0x2 && tbyte(addr) > 0

function CreateHitTargetedAndNextChain(permutation)
{
    trigger = always_true()
    
    for condition in permutation
    {
        trigger = once(trigger && once(condition))
    }
    
    return trigger
}
