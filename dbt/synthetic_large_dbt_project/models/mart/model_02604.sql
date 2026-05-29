{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01676') }},
        {{ ref('model_01654') }},
        {{ ref('model_02107') }}
)
select id, 'model_02604' as name from sources
