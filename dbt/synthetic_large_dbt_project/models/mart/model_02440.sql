{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01731') }},
        {{ ref('model_02233') }},
        {{ ref('model_01655') }}
)
select id, 'model_02440' as name from sources
