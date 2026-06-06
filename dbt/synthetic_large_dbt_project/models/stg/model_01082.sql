{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00122') }},
        {{ ref('model_00405') }},
        {{ ref('model_00248') }}
)
select id, 'model_01082' as name from sources
