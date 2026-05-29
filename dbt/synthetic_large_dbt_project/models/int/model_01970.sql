{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01137') }},
        {{ ref('model_01016') }},
        {{ ref('model_01425') }}
)
select id, 'model_01970' as name from sources
