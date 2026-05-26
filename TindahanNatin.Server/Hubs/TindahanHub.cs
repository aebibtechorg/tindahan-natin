using Microsoft.AspNetCore.SignalR;

namespace TindahanNatin.Server.Hubs;

public class TindahanHub : Hub
{
    public async Task JoinStoreGroup(string storeId)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, storeId);
    }

    public async Task LeaveStoreGroup(string storeId)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, storeId);
    }
}
