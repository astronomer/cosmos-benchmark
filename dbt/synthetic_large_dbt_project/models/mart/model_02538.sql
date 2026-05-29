{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01656') }},
        {{ ref('model_01798') }}
)
select id, 'model_02538' as name from sources
