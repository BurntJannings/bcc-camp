FeatherMenu = exports['feather-menu'].initiate()

local MyMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
    top = '40%',
    left = '20%',
    ['720width'] = '500px',
    ['1080width'] = '600px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '900px',
    style = {},
    contentslot = {
        style = { --This style is what is currently making the content slot scoped and scrollable. If you delete this, it will make the content height dynamic to its inner content.
            ['width'] = '500px',
            ['height'] = '500px',
            ['min-height'] = '300px'
        }
    },
    draggable = true,
    canclose = true
})

---------------------- Main Camp Menu Setup -----------------------------------

function MainCampmenu()                --when triggered will open the main menu
    local MyFirstPage = MyMenu:RegisterPage('first:page')
    MyFirstPage:RegisterElement('header', {
        value = _U('MenuName'),
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('bottomline', {
        slot = "header",
        style = {}
   })
    local elements = {                 --sets the main 3 elements up
    _U('DestroyCamp'),
    _U('SetFire'),
    _U('SetBench'),
    _U('SetStorageChest'),
    _U('SetHitchPost'),
    _U('SetupFTravelPost')
    }

    for f,v in pairs(elements) do
        MyFirstPage:RegisterElement('button', {
            label = v,
            style = {       
            ['background-color'] = '#E8E8E8',
             ['color'] = 'white',
             ['border-radius'] = '6px',
            }
    
        }, function(data)
            -- This gets triggered whenever the button is clicked
            print(v)

            MyMenu:Close({})
            if v == _U('DestroyCamp') then
                delcamp()
            elseif v ==  _U('SetFire') then --if option clicked is this then
                FurnMenu('campfire')
            elseif v ==  _U('SetBench') then
                FurnMenu('bench')
            elseif v ==  _U('SetStorageChest') then
                FurnMenu('storagechest')
            elseif v ==  _U('SetHitchPost') then
                FurnMenu('hitchingpost')
            elseif v ==  _U('SetupFTravelPost') then
                if Config.FastTravel.enabled then
                    spawnFastTravelPost()
                else
                    VORPcore.NotifyRightTip(_U('FTravelDisabled'), 4000)
                end
            end
        end)
        MyFirstPage:RegisterElement('line', {
            slot = "content",
            style = {}
        })
    end
    MyFirstPage:RegisterElement('bottomline', {
        slot = "footer",
        style = {}
   })
    MyMenu:Open({
        cursorFocus = true,
        menuFocus = true,
       startupPage = MyFirstPage,
   })
end

function Tpmenu()                                     --when triggered will open the main menu
    local MyFirstPage = MyMenu:RegisterPage('first:page')
    MyFirstPage:RegisterElement('header', {
        value = _U('FastTravelMenuName'),
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('bottomline', {
        slot = "header",
        style = {}
   })
    for k, v in pairs(Config.FastTravel.Locations) do --opens a for loop
        MyFirstPage:RegisterElement('button', {
            label = v.name,
            style = {},
    
        }, function(data)
            -- This gets triggered whenever the button is clicked
            MyMenu:Close({})
            SetEntityCoords(PlayerPedId(), v.coords.x, v.coords.y, v.coords.z)
        end)
    end
    MyFirstPage:RegisterElement('bottomline', {
        slot = "footer",
        style = {}
   })
    MyMenu:Open({
        cursorFocus = true,
        menuFocus = true,
       startupPage = MyFirstPage,
   })
end

-- Furniture Menu Setup
function FurnMenu(furntype)
    local MyFirstPage = MyMenu:RegisterPage('first:page')
    MyFirstPage:RegisterElement('header', {
        value = _U('FurnMenu'),
        slot = "header",
        style = {}
    })
    MyFirstPage:RegisterElement('bottomline', {
        slot = "header",
        style = {}
   })
    if furntype == 'tent' then
        for k, v in pairs(Config.Furniture.Tent) do
            MyFirstPage:RegisterElement('button', {
                label = v.name,
                style = {},
        
            }, function(data)
                local model = v.hash
                -- This gets triggered whenever the button is clicked
                MyMenu:Close({})
                spawnTent(model)
            end)
        end
    elseif furntype == 'pole' then
        for k, v in pairs(Config.Furniture.Benchs) do
            MyFirstPage:RegisterElement('button', {
                label = v.name,
                style = {},
        
            }, function(data)
                local model = v.hash
                -- This gets triggered whenever the button is clicked
                MyMenu:Close({})
                spawnPole(model)
            end)
        end
    elseif furntype == 'bench' then
        for k, v in pairs(Config.Furniture.Benchs) do
            MyFirstPage:RegisterElement('button', {
                label = v.name,
                style = {},
        
            }, function(data)
                local model = v.hash
                -- This gets triggered whenever the button is clicked
                MyMenu:Close({})
                spawnItem('bench', model)
            end)
        end
    elseif furntype == 'hitchingpost' then
        for k, v in pairs(Config.Furniture.HitchingPost) do
            MyFirstPage:RegisterElement('button', {
                label = v.name,
                style = {},
        
            }, function(data)
                local model = v.hash
                -- This gets triggered whenever the button is clicked
                MyMenu:Close({})
                spawnItem('hitchingpost', model)
            end)
        end
    elseif furntype == 'campfire' then
        for k, v in pairs(Config.Furniture.Campfires) do
            MyFirstPage:RegisterElement('button', {
                label = v.name,
                style = {},
        
            }, function(data)
                local model = v.hash
                -- This gets triggered whenever the button is clicked
                MyMenu:Close({})
                spawnItem('campfire', model)
            end)
        end
    elseif furntype == 'storagechest' then
        for k, v in pairs(Config.Furniture.StorageChest) do
            MyFirstPage:RegisterElement('button', {
                label = v.name,
                style = {},
        
            }, function(data)
                local model = v.hash
                -- This gets triggered whenever the button is clicked
                MyMenu:Close({})
                spawnItem('storagechest', model)
            end)
        end
    end
    MyFirstPage:RegisterElement('bottomline', {
        slot = "footer",
        style = {}
   })
    MyMenu:Open({
        cursorFocus = true,
        menuFocus = true,
       startupPage = MyFirstPage,
   })
end

local InputMenu = FeatherMenu:RegisterMenu('feather:input:menu', {
    top = '40%',
    left = '35%',
    ['720width'] = '500px',
    ['1080width'] = '600px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '900px',
    style = {

    },
    contentslot = {
        style = { --This style is what is currently making the content slot scoped and scrollable. If you delete this, it will make the content height dynamic to its inner content.
            ['height'] = '150px',
            ['width'] = '400px',
            ['min-height'] = '150px'
        }
    },
    draggable = false,
    canclose = true
}
)

function TriggerInput(action, label1, label2)
    local InputPage = InputMenu:RegisterPage('first:page')

    local inputValue = ''
    InputButton1 = InputPage:RegisterElement('input', {
        label = label1,
        placeholder = "Name!",
        -- persist = false,
        style = {

        }
    }, function(data)
        -- This gets triggered whenever the input value changes
        inputValue = data.value
    end)
    InputButton2 = InputPage:RegisterElement('button', {
        label = label2,
        style = {

        },

    }, function()
        TriggerConfirmation(action,inputValue,'Yes', 'No')
        -- This gets triggered whenever the button is clicked
    end)

    InputMenu:Open({

        startupPage = InputPage,

    })
end

function TriggerConfirmation(action,input, label1, label2)
    local InputPage = InputMenu:RegisterPage('first:page')

    if InputButton1 then
        InputButton1:UnRegister()
        InputButton2:UnRegister()
    end
    InputPage:RegisterElement('button', {
        label = label1,
        style = {

        },

    }, function()
        InputMenu:Close({})
        spawnPole(input)
        -- This gets triggered whenever the button is clicked
    end)
    InputPage:RegisterElement('button', {
        label = label2,
        style = {

        },

    }, function()
        InputMenu:Close({})


        -- This gets triggered whenever the button is clicked
    end)
    InputMenu:Open({

        startupPage = InputPage,

    })
end