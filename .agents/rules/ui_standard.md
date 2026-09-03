# ULTRA SCRIPT HUB - Standard UI Specification (Made by Junejo)

Whenever creating any Roblox script for the user, ALWAYS use this exact UI layout and visual aesthetic:

## 1. Visual Theme & Colors:
- **MainFrame Background**: `Color3.fromRGB(15, 15, 18)` (Sleek dark matte)
- **Corner Radius**: `UDim.new(0, 10)`
- **Border Stroke**: `UIStroke` with `Color3.fromRGB(40, 40, 48)` and thickness `1`
- **MainFrame Size**: `UDim2.new(0, 320-340, 0, calculatedHeight)`
- **Header**:
  - **Title**: Left-aligned, Bold Uppercase white text `Color3.fromRGB(255, 255, 255)`, `Enum.Font.SourceSansBold` / `Enum.Font.GothamBold`, size 13-14.
  - **Close Button (X)**: Top right `✕` text button `Color3.fromRGB(180, 180, 180)`, size 26x26.
- **Toggle Rows (Checkboxes)**:
  - **Row Height**: `36-38px`
  - **Feature Label**: Left-aligned, Bold White `Color3.fromRGB(255, 255, 255)`, size 13-14.
  - **Checkbox Button**: Right-aligned, size `20x20` or `22x22`, `UICorner` radius `4-6px`.
    - **Unchecked State**: Background `Color3.fromRGB(15, 15, 18)`, Border/Stroke `Color3.fromRGB(75, 80, 95)`, Text `""`.
    - **Checked State**: Background `Color3.fromRGB(255, 255, 255)`, TextColor `Color3.fromRGB(0, 0, 0)`, Text `"✓"`.
  - **Divider Line** between rows: Height `1px`, `Color3.fromRGB(35, 35, 45)`.
- **Footer**:
  - Centered:
    - `"ULTRA SCRIPT HUB"` in Bold White (`Color3.fromRGB(255, 255, 255)`), size 14.
    - `"Made by Junejo"` in Muted Gray (`Color3.fromRGB(150, 150, 150)`), size 12.
- **Mobile/Draggable Open Toggle**:
  - Floating circular/rounded button on screen edge with game emoji icon to open/close menu at any time.
