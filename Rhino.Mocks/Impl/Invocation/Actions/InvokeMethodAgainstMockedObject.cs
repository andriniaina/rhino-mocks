using Castle.Core.Interceptor;
using andri.Mocks.Interfaces;

namespace andri.Mocks.Impl.Invocation.Actions
{
    ///<summary>
    ///</summary>
    public class InvokeMethodAgainstMockedObject : IInvocationActionn
    {
        IMockedObject proxyInstance;

        ///<summary>
        ///</summary>
        public InvokeMethodAgainstMockedObject(IMockedObject proxy_instance)
        {
            proxyInstance = proxy_instance;
        }

        ///<summary>
        ///</summary>
        public void PerformAgainst(IInvocation invocation)
        {
            invocation.ReturnValue = invocation.Method.Invoke(proxyInstance, invocation.Arguments);
        }
    }
}