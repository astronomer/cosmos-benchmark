{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01969') }},
        {{ ref('model_02175') }},
        {{ ref('model_01582') }}
)
select id, 'model_02577' as name from sources
