unit Utils.FastMM;

interface

type
  TFastMM4Utils = class
    class function GetMemoryUsed(): UInt64;
    class function GetFormattedMemoryUsed(): string;
  end;

implementation

uses
  System.SysUtils,
  FastMM4;

class function TFastMM4Utils.GetMemoryUsed(): UInt64;
var
  st: TMemoryManagerState;
  sb: TSmallBlockTypeState;
begin
  GetMemoryManagerState(st);
  result := st.TotalAllocatedMediumBlockSize + st.TotalAllocatedLargeBlockSize;
  for sb in st.SmallBlockTypeStates do
  begin
    result := result + sb.UseableBlockSize * sb.AllocatedBlockCount;
  end;
end;

class function TFastMM4Utils.GetFormattedMemoryUsed(): string;
var
  aMemUsage: UInt64;
begin
  aMemUsage := GetMemoryUsed();
  if aMemUsage>=10*1024*1024 then
    Result := FormatFloat('###,###,###,###.0',aMemUsage/(1024*1024))+' MB'
  else if aMemUsage>=1024*1024 then
    Result := FormatFloat('#,###.000',aMemUsage/(1024*1024))+' MB'
  else if aMemUsage>=1024 then
    Result := FormatFloat('#,###.0',aMemUsage/1024)+' KB'
  else
    Result := FormatFloat('#.000',aMemUsage/1024)+' KB';
end;

end.
