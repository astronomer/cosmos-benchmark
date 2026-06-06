{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01135') }},
        {{ ref('model_01233') }}
)
select id, 'model_02077' as name from sources
