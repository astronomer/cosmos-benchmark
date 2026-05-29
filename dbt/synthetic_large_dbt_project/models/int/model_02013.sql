{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01276') }},
        {{ ref('model_01070') }},
        {{ ref('model_01069') }}
)
select id, 'model_02013' as name from sources
