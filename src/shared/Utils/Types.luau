-- items
export type Item = {
    Price : number,
    Name : string,
}

-- for pathfinding params (customers and workers)
export type AgentParams = {
    AgentRadius : number?,
    AgentHeight : number?,
    AgentCanJump : boolean?,
    AgentCanClimb : boolean?,
    WaypointSpacing : number?,
    Costs : {}?
}

return {}