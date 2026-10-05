# Run from the repository root. Read-only planning/runtime consistency check.
$ErrorActionPreference = 'Stop'
$runtime = Get-Content godot/assets/neon-mansion/layout/mansion_layout.json -Raw | ConvertFrom-Json
$plan = Get-Content design/mansion-map.json -Raw | ConvertFrom-Json
foreach ($pair in @(@('rooms','rooms'), @('doors','connections'), @('sockets','sockets'), @('vertical_connections','stairs'), @('reserved_wing_connections','reserved_wing_connections'))) {
    $actual = $runtime.($pair[0]) | ConvertTo-Json -Depth 100 -Compress
    $snapshot = $plan.($pair[1]) | ConvertTo-Json -Depth 100 -Compress
    if ($actual -cne $snapshot) { throw "Planning/runtime mismatch: $($pair[0])" }
}
$ids = @($plan.rooms | ForEach-Object { $_.id })
if (($ids | Select-Object -Unique).Count -ne $ids.Count) { throw 'Duplicate room IDs' }
foreach ($door in $plan.connections) {
    if ($door.room_a -notin $ids -or $door.room_b -notin $ids) { throw "Unknown room in $($door.id)" }
    if ($door.via -and $door.via -notin $ids) { throw "Unknown via room in $($door.id)" }
}
foreach ($socket in $plan.sockets) {
    if ($socket.room_id -notin $ids) { throw "Unknown socket room: $($socket.socket_id)" }
}
if (($plan.socket_ids | Select-Object -Unique).Count -ne $plan.sockets.Count) { throw 'Socket inventory mismatch' }
foreach ($id in $plan.critical_route) {
    if ($id -notin $ids) { throw "Unknown critical-route room: $id" }
}
Write-Output "Planning/runtime match: $($ids.Count) spaces, $($plan.connections.Count) doors, $($plan.sockets.Count) sockets, $($plan.stairs.Count) stairs."
