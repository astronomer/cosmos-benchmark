{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00979') }},
        {{ ref('model_00923') }}
)
select id, 'model_02165' as name from sources
