using Castle.Core.Interceptor;
using andri.Mocks.Interfaces;

namespace andri.Mocks.Impl.Invocation.Actions
{
    ///<summary>
    ///</summary>
    public class Proceed : IInvocationActionn
    {
        ///<summary>
        ///</summary>
        public void PerformAgainst(IInvocation invocation)
        {
            invocation.Proceed();
        }
    }
}