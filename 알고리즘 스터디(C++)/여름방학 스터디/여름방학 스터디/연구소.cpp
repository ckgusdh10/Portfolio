#include "stdafx.h"

#include <iostream>
#include <queue>


using namespace std;

int N, M;
int base_lab[8][8];
int lab[8][8];
int ans = 0;


void Spread()
{
	int spread_lab[8][8];

	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
		{
			spread_lab[i][j] = lab[i][j];
		}
	}

	queue<pair<int, int>> q;

	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
		{
			if (spread_lab[i][j] == 2)
			{
				q.push(make_pair(i, j));
			}
		}
	}

	while (!q.empty())
	{
		int x = q.front().first;
		int y = q.front().second;
		int DirX[] = { 0,0,-1,1 };
		int DirY[] = { -1,1,0,0 };
		q.pop();

		for (int i = 0; i < 4; ++i)
		{
			int spread_x = x + DirX[i];
			int spread_y = y + DirY[i];

			if (spread_x >= 0 && spread_x < N && spread_y >= 0 && spread_y < M)
			{
				if (spread_lab[spread_x][spread_y] == 0)
				{
					spread_lab[spread_x][spread_y] = 2;
					q.push(make_pair(spread_x, spread_y));
				}
			}
		}
	}

	int cnt = 0;
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
		{
			if (spread_lab[i][j] == 0)
				cnt++;
		}
	}

	if (cnt > ans)
		ans = cnt;

}

void wall(int wall_cnt)
{
	if (wall_cnt == 3)
	{
		Spread();
		/*for (int i = 0; i < N; ++i)
		{
		for (int j = 0; j < M; ++j)
		{
		cout << lab[i][j] << " ";
		}
		cout << endl;
		}*/
		return;
	}

	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
		{
			if (lab[i][j] == 0)
			{
				lab[i][j] = 1;
				wall(wall_cnt + 1);
				lab[i][j] = 0;
			}
		}
	}

}

int main()
{
	cin >> N >> M;

	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < M; ++j)
		{
			cin >> lab[i][j];
		}
	}

	wall(0);

	cout << ans << endl;
	return 0;
}