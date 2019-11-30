local nmap = require "nmap"
local stdnse = require "stdnse"
local table = require "table"
local http = require "http"
local shortport = require "shortport"

-- Mandetory description, author, license and categories
description = [[Lua Nmap Header grapper. This is a fully functional sample service script.]]
author = "hippi3c0w"
license = "Same as Nmap--See http://nmap.org/book/man-legal.html"
categories = {"discovery", "safe", "osint"}

-- Run this script on port 80, 443 or any other port that is identified as http or https that is an open tcp port
portrule = shortport.port_or_service({80, 443}, {"http", "https"}, {"tcp", "open"})    

--[[ ACTIONS. ]]--
action = function(host, port)
    -- Initialize local variables
    local response = {}                -- Variable for the get request
    local k, v = nil, nil            -- Variables for looping through the header[] key/value pair
    local output = {}                -- Variable for the output

    response = http.get(host, port, "/")        -- Do the request and put the reply in the response variable

    if response.status                            -- If the response.status is not nil
    and response.status ~=404                    -- And not a 404
    then                                        -- then
        for k, v in pairs(response.header) do                                                -- Loop through the headers in the response
            table.insert(output, k:upper() .. ": " .. response.header[k] .. ": " .. v)        -- Put each header key/value pair in the output variable. The key is set to upper case
        end
    table.sort(output)                            -- Sort the output
    return stdnse.format_output(true, output)    -- Return the output to NSE
    else
        return response["status-line"]            -- If something went wrong, send the error message to NSE
    end
end
