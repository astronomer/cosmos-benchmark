{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01181') }},
        {{ ref('model_00998') }},
        {{ ref('model_00965') }}
)
select id, 'model_01894' as name from sources
