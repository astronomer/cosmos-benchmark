{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01931') }},
        {{ ref('model_01580') }},
        {{ ref('model_01877') }}
)
select id, 'model_02625' as name from sources
