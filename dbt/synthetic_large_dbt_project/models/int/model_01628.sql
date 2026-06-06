{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01134') }},
        {{ ref('model_00960') }}
)
select id, 'model_01628' as name from sources
