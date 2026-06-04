{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01345') }},
        {{ ref('model_01479') }},
        {{ ref('model_01102') }}
)
select id, 'model_02141' as name from sources
