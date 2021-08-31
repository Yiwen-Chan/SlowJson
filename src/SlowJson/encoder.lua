local sub, rep = string.sub, string.rep;
local insert, concat, remove = table.insert, table.concat, table.remove;

local function encode_error(err)
    error("\n" .. "An error has occurred during SlowJson encoding" .. "\n" .. err);
end

local function encoder(obj)
    if type(obj) ~= "table" then
        encode_error("Input should be a table");
        return ""
    end

    local cache = {}; -- ��ǰԪ�ػ���
    local array = 0; -- ��ǰ�������Ԫ�ظ���
    local prefix = "{"; -- Ĭ�ϼ�ֵ�����Ϳ�ͷ
    local suffix = "}"; -- Ĭ�ϼ�ֵ�����ͽ�β

    -- ת���ַ�
    -- TODE: ��ʱ��������
    local function escape(text)
        return string.gsub(text, "\"", "\\\"");
    end

    -- ��ʼ����
    for k, v in pairs(obj) do
        if type(k) == "number" and k <= #obj then
            array = array + 1;
            if type(v) == "table" then
                table.insert(cache, encode(v));
            elseif type(v) == "string" then
                table.insert(cache, "\"" .. escape(v) .. "\"");
            else
                table.insert(cache, tostring(v));
            end
        elseif type(k) == "string" then
            if type(v) == "table" then
                table.insert(cache, "\"" .. escape(k) .. "\":" .. encode(v));
            elseif type(v) == "string" then
                table.insert(cache, "\"" .. escape(k) .. "\":" .. "\"" .. escape(v) .. "\"");
            else
                table.insert(cache, "\"" .. escape(k) .. "\":" .. tostring(v));
            end
        else
            encode_error("Key can not be a " .. type(k));
        end
    end
    if #obj ~= 0 and array == #obj then
        prefix = "[";
        suffix = "]";
    elseif #obj ~= 0 then
        encode_error("Missing key value");
    end
    return prefix .. table.concat(cache, ",") .. suffix;
end

return encoder;